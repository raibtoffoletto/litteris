project('com.github.raibtoffoletto.litteris', 'vala', 'c')

i18n = import('i18n')
gnome = import('gnome')
gettext_name = meson.project_name()
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(gettext_name), language:'c')

subdir ('src')
subdir ('data')
subdir ('po')

meson.add_install_script('meson/post_install.py')
