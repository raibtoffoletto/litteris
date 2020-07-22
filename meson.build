project('com.github.raibtoffoletto.litteris', 'vala', 'c', version: '0.1.6')

gnome = import('gnome')
i18n = import('i18n')

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

subdir('src')
subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py')
