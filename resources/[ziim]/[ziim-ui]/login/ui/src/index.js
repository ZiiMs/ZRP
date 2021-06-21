import React from "react"
import ReactDOM from "react-dom"
import App from './component/App';
import { NuiProvider } from "fivem-nui-react-lib"
import {ChakraProvider} from "@chakra-ui/react"
import theme from './theme';

ReactDOM.render(
  <>
    <ChakraProvider theme={theme}>
      <NuiProvider resource="login">
        <App />
      </NuiProvider>
    </ChakraProvider>
  </>,
  document.getElementById('app')
)