import * as React from 'react';
import { render } from '@testing-library/react';

import { Confirmation } from '..';

describe('<Confirmation  />', () => {
  it('should match snapshot', () => {
    const loadingIndicator = render(<Confirmation />);
    expect(loadingIndicator.container.firstChild).toMatchSnapshot();
  });
});
