/**
 *
 * Asynchronously loads the component for Confirmation
 *
 */

import { lazyLoad } from 'utils/loadable';

export const Confirmation = lazyLoad(
  () => import('./index'),
  module => module.Confirmation,
);
