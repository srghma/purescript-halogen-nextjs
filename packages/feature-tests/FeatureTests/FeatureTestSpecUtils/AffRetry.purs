module FeatureTests.FeatureTestSpecUtils.AffRetry where

import Effect.Aff.Retry
import Protolude

import Data.Array (uncons)
import Effect.Aff (delay)
import Prim.Row (class Cons) as Row
import Run (Run, AFF)
import Run as Run
import Run.Except (EXCEPT)
import Run.Except as Run
import Unsafe.Coerce (unsafeCoerce)

type Check = RetryStatus -> Error -> Aff Boolean

-- from https://github.com/purescript-webrow/webrow/blob/68144f421b6652b93bb9ceeb9ed69762286ae905/src/WebRow/PostgreSQL/PG.purs#L135
--
-- | Run.expand definition is based on `Union` constraint
-- | We want to use Row.Cons here instead
expand' ∷ ∀ l b t t_. Row.Cons l b t_ t ⇒ SProxy l → Run t_ ~> Run t
expand' _ = unsafeCoerce

runExcept' ∷ ∀ e a r. Run (except ∷ EXCEPT e | r) a → Run (except ∷ EXCEPT e | r) (Either e a)
runExcept' = expand' (SProxy :: SProxy "except") <<< Run.runExcept


retrying
  :: ∀ b r
   . RetryPolicyM Aff
  -> (RetryStatus -> b -> Run ( aff :: AFF | r ) Boolean) -- An action to check whether the result should be retried.
                                     -- If True, we delay and retry the operation.
  -> (RetryStatus -> Run ( aff :: AFF | r ) b)            -- Action to run
  -> Run ( aff :: AFF | r ) b
retrying policy check action = go defaultRetryStatus
  where
  go status = do
    res <- action status
    ifM (check status res)
      (Run.liftAff (applyAndDelay policy status) >>= maybe (pure res) go)
      (pure res)

recovering
  :: ∀ r a
   . RetryPolicyM Aff
  -> Array Check
  -> (RetryStatus -> Run ( aff :: AFF, except ∷ EXCEPT Error | r ) a)
  -> Run ( aff :: AFF, except ∷ EXCEPT Error | r ) a
recovering policy checks f = go defaultRetryStatus
  where
    go :: RetryStatus -> Run ( aff :: AFF, except ∷ EXCEPT Error | r ) a
    go status = runExcept' (f status) >>= either (recover checks) pure
      where
        recover
          :: Array Check
          -> Error
          -> Run ( aff :: AFF, except ∷ EXCEPT Error | r ) a
        recover chks e =
          case uncons chks of
              Nothing -> Run.throw e
              Just headTail -> handle e headTail

        handle
          :: Error
          -> { head :: Check, tail :: Array Check }
          -> Run ( aff :: AFF, except ∷ EXCEPT Error | r ) a
        handle e hs =
          Run.liftAff (hs.head status e) >>=
            if _
              then Run.liftAff (applyAndDelay policy status) >>= maybe (Run.throw e) go
              else recover hs.tail e
