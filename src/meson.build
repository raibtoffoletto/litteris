dependencies = [
    dependency('gtk+-3.0'),
    dependency('granite')
]

src_files = [
    'Application.vala',
    'Header.vala',
    'Panels.vala',
    'Window.vala',
    'Widgets/AppMenu.vala',
    'Widgets/ContactList.vala',
    'Widgets/SearchEntry.vala',
    'Widgets/Welcome.vala'
]

executable(
    meson.project_name(),
    src_files,
    dependencies: dependencies,
    install: false
)
