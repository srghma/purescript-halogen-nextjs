module.export = {
  compiler: 'psa',
  // note that warnings are shown only when file is recompiled, delete output folder to show all warnigns
  compilerOptions: {
    censorCodes: [
      'ImplicitQualifiedImport',
      'UnusedImport',
      'ImplicitImport',
    ].join(','),
    // strict: true
  }
}
