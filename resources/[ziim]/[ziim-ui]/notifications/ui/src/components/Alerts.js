/* eslint-disable react-hooks/rules-of-hooks */
import React, { useState } from 'react';
import {
  chakra, Box, Icon, Flex, useColorModeValue,
} from '@chakra-ui/react';

import { IoMdCheckmarkCircle, IoMdAlert } from 'react-icons/io';
import { BsLightningFill } from 'react-icons/bs';

const Alerts = (props) => {
  const [data] = useState(props);

  switch (data.type) {
    case 'success':
      return (
        <Flex
          maxW="sm"
          w="full"
          mx="auto"
          bg={useColorModeValue('white', 'gray.800')}
          shadow="md"
          rounded="lg"
          overflow="hidden"
        >
          <Flex justifyContent="center" alignItems="center" w={12} bg="green.500">
            <Icon as={IoMdCheckmarkCircle} color="white" boxSize={6} />
          </Flex>

          <Box mx={-3} py={2} px={4}>
            <Box mx={3}>
              <chakra.span
                color={useColorModeValue('green.500', 'green.400')}
                fontWeight="bold"
              >
                {data.header}
              </chakra.span>
              <chakra.p
                color={useColorModeValue('gray.600', 'gray.200')}
                fontSize="sm"
              >
                {data.text}
              </chakra.p>
            </Box>
          </Box>
        </Flex>
      );
    case 'info':
      return (
        <Flex
          maxW="sm"
          w="full"
          mx="auto"
          bg={useColorModeValue('white', 'gray.800')}
          shadow="md"
          rounded="lg"
          overflow="hidden"
        >
          <Flex justifyContent="center" alignItems="center" w={12} bg="blue.500">
            <Icon as={IoMdAlert} color="white" boxSize={6} />
          </Flex>

          <Box mx={-3} py={2} px={4}>
            <Box mx={3}>
              <chakra.span
                color={useColorModeValue('blue.500', 'blue.400')}
                fontWeight="bold"
              >
                {data.header}
              </chakra.span>
              <chakra.p
                color={useColorModeValue('gray.600', 'gray.200')}
                fontSize="sm"
              >
                {data.text}
              </chakra.p>
            </Box>
          </Box>
        </Flex>
      );
    case 'warn':
      return (
        <Flex
          maxW="sm"
          w="full"
          mx="auto"
          bg={useColorModeValue('white', 'gray.800')}
          shadow="md"
          rounded="lg"
          overflow="hidden"
        >
          <Flex
            justifyContent="center"
            alignItems="center"
            w={12}
            bg="yellow.500"
          >
            <Icon as={IoMdAlert} color="white" boxSize={6} />
          </Flex>

          <Box mx={-3} py={2} px={4}>
            <Box mx={3}>
              <chakra.span
                color={useColorModeValue('yellow.400', 'yellow.300')}
                fontWeight="bold"
              >
                {data.header}
              </chakra.span>
              <chakra.p
                color={useColorModeValue('gray.600', 'gray.200')}
                fontSize="sm"
              >
                {data.text}
              </chakra.p>
            </Box>
          </Box>
        </Flex>
      );
    case 'error':
      return (

        <Flex
          maxW="sm"
          w="full"
          mx="auto"
          bg={useColorModeValue('white', 'gray.800')}
          shadow="md"
          rounded="lg"
          overflow="hidden"
        >
          <Flex justifyContent="center" alignItems="center" w={12} bg="red.500">
            <Icon as={BsLightningFill} color="white" boxSize={6} />
          </Flex>

          <Box mx={-3} py={2} px={4}>
            <Box mx={3}>
              <chakra.span
                color={useColorModeValue('red.500', 'red.400')}
                fontWeight="bold"
              >
                {data.header}
              </chakra.span>
              <chakra.p
                color={useColorModeValue('gray.600', 'gray.200')}
                fontSize="sm"
              >
                {data.text}
              </chakra.p>
            </Box>
          </Box>
        </Flex>
      );
    default:
      return (

        <Flex
          maxW="sm"
          w="full"
          mx="auto"
          bg={useColorModeValue('white', 'gray.800')}
          shadow="md"
          rounded="lg"
          overflow="hidden"
        >
          <Flex justifyContent="center" alignItems="center" w={12} bg="green.500">
            <Icon as={IoMdCheckmarkCircle} color="white" boxSize={6} />
          </Flex>

          <Box mx={-3} py={2} px={4}>
            <Box mx={3}>
              <chakra.span
                color={useColorModeValue('green.500', 'green.400')}
                fontWeight="bold"
              >
                {data.header}
              </chakra.span>
              <chakra.p
                color={useColorModeValue('gray.600', 'gray.200')}
                fontSize="sm"
              >
                {data.text}
              </chakra.p>
            </Box>
          </Box>
        </Flex>
      );
  }
};

export default Alerts;
