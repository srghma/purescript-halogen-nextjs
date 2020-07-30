module Classes.RMWC.List (rmwc_collapsible_list, rmwc_collapsible_list__children, rmwc_collapsible_list____open, rmwc_collapsible_list__handle, mdc_list_item__meta, mdc_list_item, rmwc_collapsible_list__children_inner) where

import Halogen.HTML (ClassName(..))

rmwc_collapsible_list :: ClassName
rmwc_collapsible_list = ClassName "rmwc-collapsible-list"

rmwc_collapsible_list__children :: ClassName
rmwc_collapsible_list__children = ClassName "rmwc-collapsible-list__children"

rmwc_collapsible_list____open :: ClassName
rmwc_collapsible_list____open = ClassName "rmwc-collapsible-list--open"

rmwc_collapsible_list__handle :: ClassName
rmwc_collapsible_list__handle = ClassName "rmwc-collapsible-list__handle"

mdc_list_item__meta :: ClassName
mdc_list_item__meta = ClassName "mdc-list-item__meta"

mdc_list_item :: ClassName
mdc_list_item = ClassName "mdc-list-item"

rmwc_collapsible_list__children_inner :: ClassName
rmwc_collapsible_list__children_inner = ClassName "rmwc-collapsible-list__children-inner"

