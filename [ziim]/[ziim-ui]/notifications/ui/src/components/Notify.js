/* eslint-disable react-hooks/rules-of-hooks */
import React, { useState } from 'react';
import {
  chakra,
  Box,
  Flex,
  useColorModeValue,
  // Icon,

} from '@chakra-ui/react';

// import { IoMdCheckmarkCircle } from 'react-icons/io';

const Notify = (props) => {
  const [data] = useState(props);

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
      <Flex w={2} bg={useColorModeValue('gray.800', 'gray.900')} />

      <Flex alignItems="center" px={2} py={3}>
        {/* <Icon as={data.icon} color="green" boxSize={6} /> */}
        <Box mx={3}>
          <chakra.p color={useColorModeValue('gray.600', 'gray.200')}>
            {data.text}
          </chakra.p>
        </Box>
      </Flex>
    </Flex>
  );
};

export default Notify;
