import { useToast } from '@chakra-ui/react';
import React, { useCallback, useEffect } from 'react';
import { store } from '../index';
import Notify from '../components/Notify';
import Alerts from '../components/Alerts';
import Nui from '../Nui';

Nui.onEvent('Notify', (payload) => {
  store.dispatch({ type: 'Notify', payload });
});

const Notifications = () => {
  const toast = useToast();

  const handleAlerts = (type, text, style, header) => {
    if (text !== '') {
      switch (style) {
        case 'alert': {
          toast({
            position: 'top-right',
            // eslint-disable-next-line react/display-name
            render: () => (<Alerts text={text} header={header} type={type} />),
          });
          break;
        }
        case 'notify': {
          toast({
            position: 'top-right',
            // eslint-disable-next-line react/display-name
            render: () => (<Notify text={text} />),
          });
          break;
        }
        default:
      }
    }
  };

  const handleKeyPress = useCallback(
    (e) => {
      // Press U to trigger Event
      if (e.keyCode === 85) {
        e.preventDefault();
        // console.log(show);
        Nui.emitEvent('Notify', {
          type: 'warn', text: 'Text', header: 'headers', style: 'notify',
        });
        // toggle = !toggle;
      }
    },
  );

  useEffect(() => {
    document.addEventListener('keydown', handleKeyPress, false);

    return () => {
      document.removeEventListener('keydown', handleKeyPress, false);
    };
  }, [handleKeyPress]);

  store.subscribe(() => {
    const payload = store.getState();
    handleAlerts(
      payload.notification.type,
      payload.notification.text,
      payload.notification.style,
      payload.notification.header,
    );
  });

  return (
    <div />
  );
};

export default Notifications;
