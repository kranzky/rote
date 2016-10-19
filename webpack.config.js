module.exports = {
  entry: {
    application: ['./src/js/application.coffee', './src/css/application.sass']
  },
  output: {
    filename: '[name].js',
    path: './www/js',
  },
  devtool: 'source-map',
  devServer: {
    contentBase: './www',
    publicPath: '/js/'
  },
  module: {
    loaders: [
      { test: /\.coffee$/, loaders: ['coffee'] },
      { test: /\.sass$/, loaders: ['style', 'css', 'sass'] }
    ]
  }
}
