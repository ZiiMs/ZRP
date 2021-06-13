/* eslint-disable react/jsx-key */
/* eslint-disable react/jsx-props-no-spreading */
import React, {
  useEffect, useCallback, useState,
} from 'react';
import {
  Table,
  Thead,
  Tbody,
  Tr,
  Th,
  useColorModeValue,
  // Flex,
  Td,
  TableCaption,
  // Container,
  Box,
  Flex,
} from '@chakra-ui/react';
import Pagination from '@choc-ui/paginator';
import { useSelector, store } from '../../index';
import Nui from '../../Nui';

// const useStyles = {
//   background: {
//     display: 'flex',
//     // position: 'fill',
//     height: '100%',
//     width: '100%',
//     backgroundImage: 'url(https://cdn.discordapp.com/attachments/655453054522621964/669602739545964564/20190715004102_1.jpg)',
//   },
// };

const App = () => {
  const show = useSelector((state) => state.Scoreboard.show);
  const [current, setCurrent] = useState(1);
  const pageSize = 15;
  const offset = (current - 1) * pageSize;
  const [data, setData] = useState([]);

  Nui.onEvent('scoreboardShow', (payload) => {
    store.dispatch({ type: 'scoreboardShow', payload });
    setData(payload.players ? payload.players : []);
  });

  Nui.onEvent('scoreboardUpdate', (payload) => {
    store.dispatch({ type: 'scoreboardUpdate', payload });
  });

  // const [loading, setLoading] = useState(true);

  // const flexBg = useColorModeValue('white', 'gray.800');
  // const gridBg = useColorModeValue('gray.100', 'gray.700');
  // const gridColor = useColorModeValue('gray.500');
  // const [data, setData] = useState([]);
  // const data = [];

  // const setupData = () => {
  //   const returnData = [];
  //   // eslint-disable-next-line no-plusplus
  //   for (let i = 0; i < 500; i++) {
  //     // const name = `Test${i}`;
  //     const license = `license:7e5a718514a9dfd78920a66998a036b14b3a2a3${i}`;
  //     const id = i;
  //     const tempData = { license, id };
  //     returnData.push(tempData);
  //     // setData([...data + tempData]);
  //   }
  //   return returnData;
  // };

  // setupData();
  const posts = data.slice(offset, offset + pageSize);
  // const classes = useStyles();

  const handleKeyPress = useCallback(
    (e) => {
      // Press U to trigger Event
      if (e.keyCode === 85 || e.keyCode === 27) {
        e.preventDefault();
        Nui.post('closeScoreboard');
        store.dispatch({ type: 'scoreboardShow', payload: { show: false } });
        setCurrent(1);
      }
      if (e.keyCode === 37) {
        e.preventDefault();
        const page = current - 1;
        setCurrent(Math.min(Math.max(page, 1), Math.ceil(data.length / pageSize)));
      }
      if (e.keyCode === 39) {
        e.preventDefault();
        const page = current + 1;
        setCurrent(Math.min(Math.max(page, 1), Math.ceil(data.length / pageSize)));
      }
    }, [current, data.length],
  );

  store.subscribe(() => {
    const { move } = store.getState();
    if (move === 'left') {
      const page = current - 1;
      setCurrent(Math.min(Math.max(page, 1), Math.ceil(data.length / pageSize)));
    } else if (move === 'left') {
      const page = current + 1;
      setCurrent(Math.min(Math.max(page, 1), Math.ceil(data.length / pageSize)));
    }
  });

  useEffect(() => {
    document.addEventListener('keydown', handleKeyPress, false);

    return () => {
      document.removeEventListener('keydown', handleKeyPress, false);
    };
  }, [handleKeyPress]);

  return (
    <Flex justifyContent="flex-end" hidden={!show}>
      <Box
        display="flex"
        justifyContent="right"
        bg="gray.800"
        shadow="base"
        rounded="lg"
        mr={25}
        mt={10}
      >
        <Table
          size="sm"
        >
          <TableCaption>
            <Pagination
              current={current}
              onChange={(page) => {
                setCurrent(page);
                console.log(page);
              }}
              pageSize={pageSize}
              total={data.length}
              paginationProps={{
                display: 'flex',
                justifyContent: 'center',
              }}
              activeStyles={{
                bg: useColorModeValue('brand.600', '#4d5499'),
              }}
            />
          </TableCaption>
          <Thead>
            <Tr>
              <Th>Id</Th>
              {/* <Th>Name</Th> */}
              <Th>License</Th>
            </Tr>
          </Thead>
          <Tbody>
            {posts.map((post) => (
              <Tr key={post.id}>
                <Td>{post.id}</Td>
                {/* <Td>{post.name}</Td> */}
                <Td>{post.license}</Td>
              </Tr>
            ))}
          </Tbody>
        </Table>
      </Box>
    </Flex>
  );
};

export default App;
