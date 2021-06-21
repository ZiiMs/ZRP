import { extendTheme } from '@chakra-ui/react';
// 2. Add your color mode config
const theme = extendTheme({
  colors: {
      brand: {
        50: "#ecefff",
        100: "#cbceeb",
        200: "#a9aed6",
        300: "#888ec5",
        400: "#666db3",
        500: "#4d5499",
        600: "#3c4178",
        700: "#2a2f57",
        800: "#181c37",
        900: "#080819",
      },
  },
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
});
// 3. extend the theme
// const theme = extendTheme({ config });
export default theme;
