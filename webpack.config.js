module.exports = {
  entry: {
    script: './src/js/application.coffee',
    style: './src/css/application.sass'
  },
  output: {
    path: './www/js',
    filename: 'application.[name].js'
  },
  module: {
    loaders: [
      { test: /\.coffee$/, loaders: ['coffee'] },
      { test: /\.sass$/, loaders: ['style', 'css', 'sass'] }
    ]
  }
}
