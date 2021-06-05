/* eslint-disable no-undef */
const events = {
  key: Function,
};

export default class Nui {
  // eslint-disable-next-line no-undef
  static post(event, data = {}, resName = GetParentResourceName()) {
    return fetch(`https://${resName}/${event}`, {
      method: 'POST',
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify(data),
    });
  }

  static onEvent(type, func) {
    if (events[type]) {
      return;
    }
    events[type] = func;
  }

  static emitEvent(type, payload) {
    window.dispatchEvent(new MessageEvent('message', {
      data: { type, payload },
    }));
  }
}

export const EventListener = () => {
  window.addEventListener('message', (e) => {
    if (!events[e.data.type]) return;
    events[e.data.type](e.data.payload);
  });
  return null;
};
