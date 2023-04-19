import * as React from 'react';
import { render } from '@testing-library/react';

import { ModuleInputs } from '..';

describe('<ModuleInputs  />', () => {
  it('should match snapshot', () => {
    const loadingIndicator = render(<ModuleInputs />);
    expect(loadingIndicator.container.firstChild).toMatchSnapshot();
  });
});
