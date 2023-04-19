/**
 *
 * RegistryList
 *
 */
import React, { useEffect } from 'react';
import styled from 'styled-components/macro';
import { useSelector, useDispatch } from 'react-redux';
import { InputGroup, Container, Row, Col } from 'react-bootstrap';
import { useModuleRegistryFormStateSlice } from './slice';
import { selectFilter, selectModulesRegistry } from './slice/selectors';
import { RegistryModuleItem } from './RegistryModuleItem';

export function RegistryList() {
  const { actions } = useModuleRegistryFormStateSlice();

  const registryModules = useSelector(selectModulesRegistry);
  const filter = useSelector(selectFilter);

  const dispatch = useDispatch();

  const useEffectOnMount = (effect: React.EffectCallback) => {
    // eslint-disable-next-line react-hooks/exhaustive-deps
    useEffect(effect, []);
  };

  useEffectOnMount(() => {
    // Load registry modules
    dispatch(actions.loadRegistryModules());
  });

  const onChangeModuleName = (name: String) => {
    dispatch(actions.changeModuleName('' + name));
  };

  const onChangeModuleVersion = (version: String) => {
    dispatch(actions.changeModuleVersion('' + version));
  };

  const onChangeModuleProvider = (provider: String) => {
    dispatch(actions.changeModuleProvider('' + provider));
  };

  const onChangeModuleSpwUrl = (spw_url: String) => {
    dispatch(actions.changeModuleSpwUrl('' + spw_url));
  };

  const onChangeModuleSpwProvider = (spw_provider: String) => {
    dispatch(actions.changeModuleSpwProvider('' + spw_provider));
  };

  const onChangeFilter = (evt: React.ChangeEvent<HTMLInputElement>) => {
    let provider = evt.target.value;
    let checked = evt.target.checked;
    let array = Object.assign([], filter);
    if (checked) {
      array.push(provider);
      array = Object.assign([], Array.from(new Set(array)));
      dispatch(actions.changeFilter(array));
    } else {
      let new_array = array.filter(e => e !== provider);
      dispatch(actions.changeFilter(new_array));
    }
  };

  const getFilteredRegistryModules = () => {
    if (filter?.length > 0) {
      let regex = '';
      filter.map((filterVal, index) => {
        if (index === 0) regex = regex + filterVal;
        else regex = regex + '|' + filterVal;
        return null;
      });
      const regexValue = new RegExp('^(' + regex + ')$');
      return registryModules.data?.length > 0
        ? registryModules.data.filter(module =>
            module.attributes.provider.match(regexValue),
          )
        : [];
    } else return registryModules.data?.length > 0 ? registryModules.data : [];
  };

  return (
    <>
      <Container>
        <Title>{'Modules'}</Title>
        <RegistrySectionRow>
          <CustomCol md="3">
            <FilterRow>
              <Filters>{'Filters'}</Filters>
              <ClearFilters>{'Clear Filters'}</ClearFilters>
            </FilterRow>
            <ProvidersRow>
              <Providers>{'Providers'}</Providers>
              <InputGroup>
                <InputCheckbox value="aws" onClick={onChangeFilter} />
                <InputText>{'AWS'}</InputText>
              </InputGroup>
              <InputGroup>
                <InputCheckbox value="azurerm" onClick={onChangeFilter} />
                <InputText>{'Azure'}</InputText>
              </InputGroup>
              <InputGroup>
                <InputCheckbox value="gcp" onClick={onChangeFilter} />
                <InputText>{'GCP'}</InputText>
              </InputGroup>
            </ProvidersRow>
          </CustomCol>
          <CustomCol md="9">
            <ModulesContainer>
              {getFilteredRegistryModules().map(registryModule => (
                <RegistryModuleItem
                  registryModule={registryModule}
                  onChangeModuleName={onChangeModuleName}
                  onChangeModuleVersion={onChangeModuleVersion}
                  onChangeModuleProvider={onChangeModuleProvider}
                  onChangeModuleSpwUrl={onChangeModuleSpwUrl}
                  onChangeModuleSpwProvider={onChangeModuleSpwProvider}
                />
              ))}
            </ModulesContainer>
          </CustomCol>
        </RegistrySectionRow>
      </Container>
    </>
  );
}

const ModulesContainer = styled(Container)`
  padding: 1.5rem;
  border-left: 1px solid #dce0e6;
  min-height: 250px;
`;

const CustomCol = styled(Col)`
  padding: 0;
  margin: 0;
`;

const RegistrySectionRow = styled(Row)`
  border: 1px solid #dce0e6;
`;

const FilterRow = styled(Row)`
  padding: 1.5rem;
  margin: 0;
`;

const ProvidersRow = styled(Row)`
  border-top: 1px solid #dce0e6;
  padding: 0.5rem 1.5rem 1.5rem;
  margin: 0;
`;

const Title = styled.h2`
  font-size: 1.286rem !important;
  font-weight: 600;
  color: #000;
`;

const Filters = styled.span`
  color: #525761;
  font-size: 1.286rem;
  font-weight: 400;
  line-height: 1.25;
  margin: 0;
  display: inline-block;
  width: auto;
`;

const ClearFilters = styled.span`
  color: rgb(21, 99, 255);
  cursor: pointer;
  text-decoration: none;
  display: inline-block;
  width: auto;
  margin-left: 5rem;
`;

const Providers = styled.p`
  color: #525761;
  padding-bottom: 0.5rem;
  padding-top: 0.5rem;
  font-size: 1rem;
  font-weight: 400;
`;

const InputText = styled(InputGroup.Text)`
  color: #000;
  line-height: 1.25;
  font-size: 0.8rem;
  cursor: pointer;
  margin-left: 0.5rem;
`;

const InputCheckbox = styled(InputGroup.Checkbox)`
  cursor: pointer;
`;
