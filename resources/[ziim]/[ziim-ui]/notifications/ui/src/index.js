import React from 'react';
import ReactDOM from 'react-dom';
import { useSelector as useReduxSelector, Provider } from 'react-redux';
import { createStore } from 'redux';
import { ChakraProvider } from '@chakra-ui/react';

import Notifications from './containers/Notifications';
import rootReducer from './reducers';
import { EventListener } from './Nui';
import theme from './theme';

export const store = createStore(rootReducer, {});

export const useSelector = useReduxSelector;

ReactDOM.render(
  <Provider store={store}>
    <ChakraProvider theme={theme}>
      <Notifications />
      <EventListener />
    </ChakraProvider>
  </Provider>,
  document.getElementById('app'),
);
