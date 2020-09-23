module.exports = {
  output:    require('webpack-spago-loader/lib/getAbsoluteOutputDirFromSpago')('./spago.dhall'),
  pursFiles: require('webpack-spago-loader/lib/getSourcesFromSpago')('./spago.dhall'),

  compiler: 'psa',
  // note that warnings are shown only when file is recompiled, delete output folder to show all warnings
  compilerOptions: {
    censorCodes: [
      'ImplicitQualifiedImport',
      'UnusedImport',
      'ImplicitImport',
    ].join(','),
    // strict: true
  }
}
