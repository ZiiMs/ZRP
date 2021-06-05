import React from 'react';
import ReactDOM from 'react-dom';
import { useSelector as useReduxSelector, Provider } from 'react-redux';
import { createStore } from 'redux';
import { ChakraProvider } from '@chakra-ui/react';

import TextBox from './containers/textBox';
import rootReducer from './reducers';
import { EventListener } from './Nui';
import theme from './theme';

export const store = createStore(rootReducer, {});

export const useSelector = useReduxSelector;

ReactDOM.render(
  <>
    {/* <ColorModeScript initialColorMode="dark" /> */}
    <Provider store={store}>
      <ChakraProvider theme={theme}>
        <TextBox />
        <EventListener />
      </ChakraProvider>
    </Provider>
  </>,
  document.getElementById('app'),
);
