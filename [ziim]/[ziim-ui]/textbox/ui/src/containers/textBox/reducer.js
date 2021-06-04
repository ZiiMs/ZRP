const IShow = {
  type: String,
  payload: Object,
  show: Boolean,
  key: Number,
  players: Object,
};

const initialState = {
  show: false,
  title: 'Title',
  placeholder: 'Placeholder',
};

const Textbox = (
  state = initialState,
  data = IShow,
) => {
  console.log(JSON.stringify(data.payload));
  switch (data.type) {
    case 'Textbox':
      return {
        ...state,
        show: data.payload.show,
        title: data.payload.title,
        placeholder: data.payload.placeholder,
      };
    default:
      return state;
  }
};

export default Textbox;
