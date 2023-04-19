import * as React from 'react';
import { render } from '@testing-library/react';

import { RegistryList } from '..';

describe('<RegistryList  />', () => {
  it('should match snapshot', () => {
    const loadingIndicator = render(<RegistryList />);
    expect(loadingIndicator.container.firstChild).toMatchSnapshot();
  });
});
