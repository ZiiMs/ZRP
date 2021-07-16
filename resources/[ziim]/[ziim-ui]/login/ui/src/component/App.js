import { useNuiEvent, useNuiCallback } from "fivem-nui-react-lib";
import React, { useState, useCallback, useEffect } from "react";
import {   chakra,
  Box,
  Text,
  Flex,
  Spinner,
  useColorModeValue,
} from "@chakra-ui/react";


const App = () => {
  const [show, setShow] = useState(false);
  const [error, setError] = useState();
  const [fetchMyMethod, { loading }] = useNuiCallback("login", "FetchData", setShow, setError)
  useNuiEvent('login', 'setShow', setShow);

  const handleKeyPress = useCallback(
    (e) => {
      // Press U to trigger Event
      console.log(show)
      if (e.keyCode === 85) {
        e.preventDefault();
        setShow(!show)
      }
      if (e.keyCode === 13) {
        e.preventDefault();
        onSubmit()
      }
    }, [show],
  );

  const onSubmit = (e) => {
    // e.preventDefault();
    fetchMyMethod();
  }

  useEffect(() => {
    document.addEventListener('keydown', handleKeyPress, false);

    return () => {
      document.removeEventListener('keydown', handleKeyPress, false);
    };
  }, [handleKeyPress]);

  return (
    <>
    {show ? (
      <Flex h="100vh" align="flex-start" bg="rgba(0, 0, 0, 0.4)">
        <Flex h="full" w="full" inset={0} position="absolute" objectFit="cover" filter="auto" blur="10px" />
        <Flex
          mt="8%"
          justify="center"
          align="center"
          zIndex={10}
          w="full"
          bg={useColorModeValue("white", "gray.800")}
        >
          <Box
            w={{ base: "full", md: "75%", lg: "50%" }}
            px={4}
            py={20}
            textAlign={{ base: "left", md: "center" }}
          >
            <chakra.h1
            fontSize={{ base: "4xl", md: "6xl" }}
            fontWeight="bold"
            lineHeight="none"
            letterSpacing={{ base: "normal", md: "tight" }}
            color={useColorModeValue("gray.900",'gray.100')}
            >
              <Text
              display={{ base: "block", lg: "inline" }}
              w="full"
              bgClip="text"
              bgGradient="linear(to-r, green.400,purple.500)"
              fontWeight="extrabold"
            >ZiiM Roleplay
              </Text>
              </chakra.h1>
              <chakra.h1
                mb={4}
                fontSize={{ base: "3xl", md: "4xl" }}
                fontWeight="bold"
                lineHeight="none"
                letterSpacing={{ base: "normal", md: "tight" }}
                color={useColorModeValue("gray.900",'gray.100')}
              >
              <chakra.span
                display="block"
                color={useColorModeValue("brand.600", "gray.500")}
              >
                Start playing today.
              </chakra.span>
              </chakra.h1>
              {error ? (
                <chakra.span>{error}</chakra.span>
              ):
            <Box display="inline-flex" rounded="md" shadow="md">
              {loading ? (
                <Spinner
                thickness="4px"
                speed="0.65s"
                emptyColor="gray.200"
                color="blue.500"
                size="xl"
              />
              ):
              <Box
                as="button"
                w="full"
                display="inline-flex"
                alignItems="center"
                justifyContent="center"
                px={5}
                py={3}
                border="solid transparent"
                fontWeight="bold"
                rounded="md"
                // onClick={onSubmit()}
                color={useColorModeValue("white")}
                bg={useColorModeValue("brand.600", "brand.500")}
                _hover={{
                  bg: useColorModeValue("brand.700", "brand.600"),
                }}
              >
                Get started
              </Box>}
            </Box>}
          </Box>
        </Flex>
      </Flex>
      ): null}
  </>
  )
}

export default App;