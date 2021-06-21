import React from "react"
import ReactDOM from "react-dom"
import App from './component/App';
import { NuiProvider } from "fivem-nui-react-lib"
import {ChakraProvider} from "@chakra-ui/react"
import theme from './theme';

ReactDOM.render(
  <>
    <NuiProvider resource="login">
      <ChakraProvider theme={theme}>
        <App />
      </ChakraProvider>
    </NuiProvider>
  </>,
  document.getElementById('app')
)