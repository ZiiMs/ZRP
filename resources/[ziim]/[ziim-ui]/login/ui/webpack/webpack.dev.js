const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: './src/index.js',
  output: {
    path: path.join(__dirname, '../dist'),
    filename: 'index.js'
  },
  devServer: {
    port: 3000,
    watchContentBase: true
  },
  module: {
    rules: [
      {
        test: /\.(ts|js)x?$/i,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        },
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      }
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './public/index.html',
      inject: true
    }),
    new webpack.HotModuleReplacementPlugin(),
  ],
  resolve: { extensions: [".tsx", ".ts", ".js", ".jsx" ] },
}