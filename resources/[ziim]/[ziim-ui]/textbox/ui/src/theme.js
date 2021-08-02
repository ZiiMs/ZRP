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
            baseStyle: () => ({
                body: {
                    bgColor: 'gray.800',
                },
                header: {
                    bgColor: 'gray.800',
                },
                footer: {
                    bgColor: 'gray.800',
                },
            }),
        },
    },
});
// 3. extend the theme
// const theme = extendTheme({ config });
export default theme;
