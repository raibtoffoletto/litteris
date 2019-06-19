dependencies = [
    dependency('gtk+-3.0'),
    dependency('granite')
]

src_files = [
    'Application.vala',
    'Header.vala',
    'Window.vala',
    'Widgets/AppMenu.vala',
    'Widgets/ContactList.vala',
    'Widgets/Penpal.vala',
    'Widgets/SearchEntry.vala',
    'Widgets/Stack.vala',
    'Widgets/Welcome.vala'
]

executable(
    meson.project_name(),
    src_files,
    dependencies: dependencies,
    install: false
)
