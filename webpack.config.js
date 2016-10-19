var webpack = require("webpack");
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
      { test: /\.sass$/, loaders: ['style', 'css', 'sass'] },
			{ test: /\.(jpe?g|png|gif|svg)$/, loaders: ['file?name=../img/[name].[ext]'] },
			{ test: /\.(eot|svg|ttf|woff|woff2)$/, loaders: ['file?name=../fonts/[name].[ext]'] }
    ]
  },
  plugins: [
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery"
    })
  ]
}
