project('com.github.raibtoffoletto.litteris', 'vala', 'c')

executable(
    meson.project_name(),
    'src/Application.vala',
    'src/Header.vala',
    'src/Panels.vala',
    'src/Window.vala',
    'src/Widgets/AppMenu.vala',
    'src/Widgets/ContactList.vala',
    'src/Widgets/SearchEntry.vala',
    'src/Widgets/Welcome.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('granite')
    ],
    install: true
)

subdir ('data')

meson.add_install_script('meson/post_install.py')
