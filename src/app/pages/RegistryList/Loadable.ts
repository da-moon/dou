/**
 *
 * Asynchronously loads the component for RegistryList
 *
 */

import { lazyLoad } from 'utils/loadable';

export const RegistryList = lazyLoad(
  () => import('./index'),
  module => module.RegistryList,
);
