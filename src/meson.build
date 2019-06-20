dependencies = [
    dependency('gtk+-3.0'),
    dependency('granite')
]

src_files = [
    'Application.vala',
    'Window.vala',
    'Widgets/AppMenu.vala',
    'Widgets/Header.vala',
    'Widgets/Penpal.vala',
    'Widgets/PenpalList.vala',
    'Widgets/SearchEntry.vala',
    'Widgets/Welcome.vala'
]

executable(
    meson.project_name(),
    src_files,
    dependencies: dependencies,
    install: false
)
