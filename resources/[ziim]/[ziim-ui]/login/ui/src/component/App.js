import { useNuiEvent } from "fivem-nui-react-lib";
import React, { useState, useCallback, useEffect } from "react";


const App = () => {
  const [show, setShow] = useState(true);
  useNuiEvent('login', 'setShow', setShow);

  const handleKeyPress = useCallback(
    (e) => {
      // Press U to trigger Event
      if (e.keyCode === 85) {
        e.preventDefault();
        setShow(!show)
      }
    }, [show],
  );

  useEffect(() => {
    document.addEventListener('keydown', handleKeyPress, false);

    return () => {
      document.removeEventListener('keydown', handleKeyPress, false);
    };
  }, [handleKeyPress]);

  return (
    <>
    {show ? (
      <div>
        <h1>Hello working?</h1>
      </div>
      ): null}
  </>
  )
}

export default App;