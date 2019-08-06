dependencies = [
    dependency('gio-2.0'),
    dependency('gtk+-3.0'),
    dependency('granite'),
    dependency('sqlite3'),
    dependency('gee-0.8')
]

src_files = [
    'Application.vala',
    'Header.vala',
    'Window.vala',
    'Models/Penpal.vala',
    'Models/MailDate.vala',
    'Services/CountryCodes.vala',
    'Services/DataBase.vala',
    'Services/Utils.vala',
    'Widgets/AppMenu.vala',
    'Widgets/PenpalDialog.vala',
    'Widgets/PenpalList.vala',
    'Widgets/PenpalView.vala',
    'Widgets/PenpalStatusBar.vala',
    'Widgets/Welcome.vala'
]

executable(
    meson.project_name(),
    src_files,
    dependencies: dependencies,
    install: true
)
