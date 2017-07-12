import * as R from 'ramda'
import * as RA from 'ramda-adjunct'

export default function webpackGetError(err, stats) {
  if (err) {
    return err // this is error object
  }

  for (let stat of stats.stats) {
    const errors = stat.compilation.errors

    if (!RA.isEmptyArray(errors)) {
      return errors // this is array
    }
  }
}
