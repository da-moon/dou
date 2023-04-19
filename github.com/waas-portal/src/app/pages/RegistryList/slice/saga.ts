import { call, put, takeLatest } from 'redux-saga/effects';
import { request } from 'utils/request';
import { moduleRegistryFormStateActions as actions } from '.';
import { RegistryModules } from 'types/RegistryModules';
import { ModuleRegistryErrorType } from './types';

export function* getRegistryModules() {
  const requestURL = `${process.env.REACT_APP_GOWRAPPER_HOST}/organization/${process.env.REACT_APP_GOWRAPPER_ORG}`;

  try {
    const result = yield call(request, requestURL);
    const registry_modules: RegistryModules = result;
    registry_modules.data = registry_modules.data.filter(module =>
      module.attributes.name.endsWith('-spw'),
    );
    if (registry_modules.data?.length > 0) {
      yield put(actions.registryModulesLoaded(registry_modules));
    } else {
      yield put(
        actions.registryModulesError(
          ModuleRegistryErrorType.HAS_NO_REGISTRY_MODULES,
        ),
      );
    }
  } catch (err) {
    yield put(
      actions.registryModulesError(ModuleRegistryErrorType.RESPONSE_ERROR),
    );
  }
}

export function* moduleRegistryFormStateSaga() {
  yield takeLatest(actions.loadRegistryModules.type, getRegistryModules);
}
