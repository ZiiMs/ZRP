import React, {
  useState, useRef, useEffect, useCallback,
} from 'react';
import {
  Modal,
  ModalOverlay,
  ModalContent,
  ModalHeader,
  ModalFooter,
  ModalBody,
  FormControl,
  FormErrorMessage,
  chakra,
  // Input,
  ModalCloseButton,
  Button,
  // Flex,
  Spacer,
} from '@chakra-ui/react';

import {
  AutoComplete,
  AutoCompleteInput,
  AutoCompleteItem,
  AutoCompleteList,
} from '@choc-ui/chakra-autocomplete';

import { useSelector, store } from '../../index';
import Nui from '../../Nui';

Nui.onEvent('Textbox', (payload) => {
  store.dispatch({ type: 'Textbox', payload });
});

// const useStyles = {
//   background: {
//     // position: 'absolute',
//     height: '100%',
//     width: '100%',
//     backgroundImage: 'url(https://cdn.discordapp.com/attachments/655453054522621964/669602739545964564/20190715004102_1.jpg)',
//   },
// };u

const TextBox = () => {
  const show = useSelector((state) => state.Textbox.show);
  const title = useSelector((state) => state.Textbox.title);
  const placeholder = useSelector((state) => state.Textbox.placeholder);
  const event = useSelector((state) => state.Textbox.event);
  const resource = useSelector((state) => state.Textbox.resource);
  // const options = ['apple', 'bannana'];
  const options = useSelector((state) => state.Textbox.autocomplete);
  const [loading, setLoading] = useState(false);
  const [input, setInput] = useState('');
  const [errorMsg, setErrorMsg] = useState('');
  const focus = useRef();
  // const dispatch = useDispatch();
  // const [open, setOpen] = useState(show);

  // const toggle = true;

  // useEffect(() => {
  //   setOpen(show);
  // }, [show]);

  const onClose = () => {
    // store.dispatch({ type: 'Textbox', payload: { show: false } });
    // dispatch({ type: 'SHOW',  });
    Nui.post('closeBox', { state: false }).then((resp) => resp.json()).then((resp) => {
      // console.log(JSON.stringify(resp));
      store.dispatch({ type: 'Textbox', payload: { show: resp.state, autocomplete: [] } });
      if (!resp.state) {
        setLoading(false);
        setInput('');
        setErrorMsg('');
      }
    });

    console.log('Closing', show);
  };

  const handleKeyPress = useCallback(
    (e) => {
      // Press U to trigger Event
      if (e.keyCode === 27) {
        e.preventDefault();
        onClose();
      }
    }, [show],
  );

  useEffect(() => {
    document.addEventListener('keydown', handleKeyPress, false);

    return () => {
      document.removeEventListener('keydown', handleKeyPress, false);
    };
  }, [handleKeyPress]);

  const handleSubmit = () => {
    // store.dispatch({ type: 'Textbox', payload: { show: false } });
    // dispatch({ type: 'SHOW',  });
    setLoading(true);
    Nui.post(event, { input }, resource).then((resp) => resp.json()).then((resp) => {
      // console.log(resp);
      // console.log(JSON.stringify(resp));
      setLoading(false);
      store.dispatch({
        type: 'Textbox',
        payload: {
          show: resp.state, title, placeholder, event, resource, autocomplete: options,
        },
      });
      if (resp.msg) {
        setErrorMsg(resp.msg);
        focus.current.focus();
      }
      if (!resp.state) {
        setInput('');
        setErrorMsg('');
      }
    });
    // console.log('Closing', show);
  };

  return (
    <div>
      {/* <h1 style={{ fontSize: '40u0px' }}>{show.toString()}</h1> */}
      <Modal
        onClose={onClose}
        isOpen={show}
        isCentered
        colorScheme="gray.800"
        autoFocus={false}
        closeOnOverlayClick={false}
        closeOnEsc
        initialFocusRef={focus}
      >
        <ModalOverlay />
        <ModalContent>
          <ModalHeader>{title}</ModalHeader>
          <ModalCloseButton />
          <chakra.form
            onSubmit={(e) => {
              e.preventDefault();
              handleSubmit();
            }}

          >
            <ModalBody>
              <FormControl isInvalid={errorMsg}>
                <AutoComplete
                  rollNavigation
                  maxSuggestions={25}
                  suggestWhenEmpty={false}
                  emptyState={false}
                  onSelectOption={(e) => setInput(e.optionValue)}
                >
                  <AutoCompleteInput isDisabled={loading} variant="filled" ref={focus} placeholder={placeholder} value={input} onChange={(e) => setInput(e.target.value)} />
                  <AutoCompleteList>
                    {options && options.map((option, oid) => (
                      // eslint-disable-next-line react/no-array-index-key
                      <AutoCompleteItem key={`option-${oid}`} value={option}>
                        {option}
                      </AutoCompleteItem>
                    ))}
                  </AutoCompleteList>
                  {/* <Input
                    ref={focus}
                    placeholder={placeholder}
                    value={input}
                    onChange={(e) => setInput(e.target.value)}
                  /> */}
                  <FormErrorMessage>{errorMsg}</FormErrorMessage>
                </AutoComplete>
              </FormControl>
            </ModalBody>
            <ModalFooter>
              <Button onClick={handleSubmit} isLoading={loading} type="submit">Submit</Button>
              <Spacer />
              <Button flex onClick={onClose}>Close</Button>
            </ModalFooter>
          </chakra.form>
        </ModalContent>
      </Modal>
    </div>
  );
};

export default TextBox;
