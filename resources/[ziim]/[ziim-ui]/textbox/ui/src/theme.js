import { extendTheme } from '@chakra-ui/react';
// 2. Add your color mode config
const theme = extendTheme({
  config: {
    initialColorMode: 'dark',
    useSystemColorMode: false,
  },
  styles: {
    global: {
    // styles for the `body`
      body: {
        bg: 'transparent',
      // color: 'white',
      },
    },
  },
  components: {
    Modal: {
      baseStyle: {
        bg: 'gray.880',
      },
    },
  },
});
// 3. extend the theme
// const theme = extendTheme({ config });
export default theme;
