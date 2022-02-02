print, 'loading packages ...'

!QUIET = 1
!except = 2

!PATH = !PATH + ':' + $
  expand_path('~/idl/end2end/') + ':' + $
  expand_path('~/idl/end2end/support_functions/') + ':' + $
  expand_path('~/idl/picc_data_analysis/') + ':' + $
  expand_path('~/idl/scenic/') + ':' + $
  expand_path('~/idl/scenic/support_functions/') + ':' + $
  expand_path('~/idl/scratch/') + ':' + $
  expand_path('~/idl/tpidl/') + ':' + $
  expand_path('~/idl/repo/astron/pro/') + ':' + $
  expand_path('~/idl/repo/carsten/') + ':' + $
  expand_path('~/idl/repo/castelli/') + ':' + $
  expand_path('~/idl/repo/cbmidl/') + ':' + $
  expand_path('~/idl/repo/cbmidl/optics/') + ':' + $
  expand_path('~/idl/repo/cbmidl/photometry/') + ':' + $
  expand_path('~/idl/repo/cbmidl/sptype/') + ':' + $
  expand_path('~/idl/repo/coyote/') + ':' + $
  expand_path('~/idl/repo/coyote/public/') + ':' + $
  expand_path('~/idl/repo/displacement_example/') + ':' + $
  expand_path('~/idl/repo/ephemeris/') + ':' + $
  expand_path('~/idl/repo/exotargets/') + ':' + $
  expand_path('~/idl/repo/exotargets/old/') + ':' + $
  expand_path('~/idl/repo/IDL_RIT_Salvaggio/') + ':' + $
  expand_path('~/idl/repo/khidl/') + ':' + $
  expand_path('~/idl/repo/khidl/kh_coyote/') + ':' + $
  expand_path('~/idl/repo/morisset/') + ':' + $
  expand_path('~/idl/repo/pds/') + ':' + $
  expand_path('~/idl/repo/pds/browse/') + ':' + $
  expand_path('~/idl/repo/piccklip-lite/') + ':' + $
  expand_path('~/idl/repo/piccklip-lite/src/') + ':' + $
  expand_path('~/idl/repo/piccsim/') + ':' + $
  expand_path('~/idl/repo/picctest/') + ':' + $
  expand_path('~/idl/repo/picctest/alpao/') + ':' + $
  expand_path('~/idl/repo/proper/') + ':' + $
  expand_path('~/idl/repo/proper/examples/') + ':' + $
  expand_path('~/idl/repo/tdemidl/') + ':' + $
  expand_path('~/idl/repo/tdemidl/piaa/') + ':' + $
  expand_path('~/idl/repo/textoidl/') + ':' + $
  expand_path('~/idl/repo/zodipic/')
  

paths = strsplit(!PATH, /extract, ':')
print, n2s(n_elements(paths),format='(I)')+' packages loaded ...'
delvar, path, index

common _$styles, _$print_style_obj, _$web_style_obj, _$screen_style_obj, _$style_obj ; load global styles

_$print_style_obj = obj_new("_style", "print")
_$web_style_obj = obj_new("_style", "web")
_$screen_style_obj = obj_new("_style")

cgwindow_setdefs, adjustsize=0
