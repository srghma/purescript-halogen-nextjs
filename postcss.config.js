module.exports = {
  plugins: [
    // require('postcss-import'),
    // require('postcss-preset-env'),
    // require('cssnano')({ preset: 'default' }),
    // ...(
    //   production ?
    //     {
    //       '@fullhuman/postcss-purgecss': {
    //         content: ['./client/**/*.js'],
    //         defaultExtractor: (content) => content.match(/[\w-/:]+(?<!:)/g) || [],
    //       }
    //     } :
    //     undefined
    // ),
    require('autoprefixer'),
  ]
}
