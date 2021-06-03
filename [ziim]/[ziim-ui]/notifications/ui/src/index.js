import React from 'react';
import ReactDOM from 'react-dom';
import { useSelector as useReduxSelector, Provider } from 'react-redux';
import { createStore } from 'redux';
// import 'rsuite/lib/styles/themes/dark/index.less';
import Notifications from './containers/Notifications';
import rootReducer from './reducers';
import { EventListener } from './Nui';

export const store = createStore(rootReducer, {});

export const useSelector = useReduxSelector;

ReactDOM.render(
  <Provider store={store}>
    <Notifications />
    <EventListener />
  </Provider>,
  document.getElementById('app'),
);
