import React from 'react';
import { Message, toaster, Notification } from 'rsuite';
// import 'rsuite/lib/styles/themes/dark/index.less';
import './Notifications.less';
import { store } from '../index';
import Nui from '../Nui';

Nui.onEvent('Notify', (payload) => {
  store.dispatch({ type: 'Notify', payload });
});

const Notifications = () => {
  const handleAlerts = (type, text, style, header) => {
    if (text !== '') {
      switch (style) {
        case 'alert': {
          toaster.push(<Message showIcon type={type} header={header}>{text}</Message>, { duration: 500, placement: 'topEnd' });
          break;
        }
        case 'notify': {
          toaster.push(<Notification type={type} header={header}>{text}</Notification>, { duration: 500, placement: 'topEnd' });
          break;
        }
        default:
      }
    }
  };

  store.subscribe(() => {
    const payload = store.getState();
    handleAlerts(
      payload.notification.type,
      payload.notification.text,
      payload.notification.style,
      payload.notification.header,
    );
  });

  return (<div />);
};

export default Notifications;
