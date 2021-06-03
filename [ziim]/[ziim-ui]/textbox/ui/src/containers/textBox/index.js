import React, {
  useState, useRef,
} from 'react';
import {
  Modal,
  ModalOverlay,
  ModalContent,
  ModalHeader,
  ModalFooter,
  ModalBody,
  FormControl,
  FormHelperText,
  chakra,
  Input,
  Text,
  ModalCloseButton,
  Button,
  // Flex,
  Spacer,
} from '@chakra-ui/react';

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
// };

const TextBox = () => {
  const show = useSelector((state) => state.Show.show);
  const [input, setInput] = useState('');
  const [errorMsg, setErrorMsg] = useState('');
  const focus = useRef();
  // const dispatch = useDispatch();
  // const [open, setOpen] = useState(show);

  // let toggle = true;

  // useEffect(() => {
  //   setOpen(show);
  // }, [show]);

  // const handleKeyPress = useCallback(
  //   (e) => {
  //     // Press U to trigger Event
  //     if (e.keyCode === 85) {
  //       e.preventDefault();
  //       console.log(show);
  //       Nui.emitEvent('Textbox', { show: !show });
  //       // toggle = !toggle;
  //     }
  //   }, [show],
  // );

  // useEffect(() => {
  //   document.addEventListener('keydown', handleKeyPress, false);

  //   return () => {
  //     document.removeEventListener('keydown', handleKeyPress, false);
  //   };
  // }, [handleKeyPress]);

  const onClose = () => {
    // store.dispatch({ type: 'Textbox', payload: { show: false } });
    // dispatch({ type: 'SHOW',  });
    Nui.post('closeBox', { state: false }).then((resp) => resp.json()).then((resp) => {
      console.log(JSON.stringify(resp));
      store.dispatch({ type: 'Textbox', payload: { show: resp.state } });
      if (!resp.state) {
        console.log('Resseting!');
        setInput('');
        setErrorMsg('');
      }
    });

    console.log('Closing', show);
  };

  const handleSubmit = () => {
    // store.dispatch({ type: 'Textbox', payload: { show: false } });
    // dispatch({ type: 'SHOW',  });
    Nui.post('submitBox', { input, state: false }).then((resp) => resp.json()).then((resp) => {
      console.log(JSON.stringify(resp));
      store.dispatch({ type: 'Textbox', payload: { show: resp.state } });
      if (resp.msg) {
        setErrorMsg(resp.msg);
      }
      if (!resp.state) {
        console.log('Resseting!');
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
        autoFocus={false}
        closeOnOverlayClick={false}
        closeOnEsc
        initialFocusRef={focus}
      >
        <ModalOverlay />
        <ModalContent>
          <ModalHeader>Modal Title</ModalHeader>
          <ModalCloseButton />
          <chakra.form
            onSubmit={(e) => {
              e.preventDefault();
              handleSubmit();
            }}

          >
            <ModalBody>
              <FormControl>
                <Text mb={8}>
                  Input: `
                  {input}
                </Text>
                <Input ref={focus} placeholder="Basic usage" value={input} onChange={(e) => setInput(e.target.value)} />
                <FormHelperText>{errorMsg}</FormHelperText>
              </FormControl>
            </ModalBody>
            <ModalFooter>
              <Button onClick={handleSubmit} type="submit">Submit</Button>
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
