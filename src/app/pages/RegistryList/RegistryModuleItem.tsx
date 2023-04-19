/* eslint-disable no-restricted-globals */
import * as React from 'react';
import styled from 'styled-components/macro';
import { Row } from 'react-bootstrap';
import { useHistory } from 'react-router-dom';

export function RegistryModuleItem({
  registryModule,
  onChangeModuleName,
  onChangeModuleVersion,
  onChangeModuleProvider,
  onChangeModuleSpwUrl,
  onChangeModuleSpwProvider,
}) {
  const history = useHistory();

  function handleClick(e, name, version, provider, spw_url, spw_provider) {
    e.preventDefault();
    onChangeModuleName(name);
    onChangeModuleVersion(version);
    onChangeModuleProvider(provider);
    onChangeModuleSpwUrl(spw_url);
    onChangeModuleSpwProvider(spw_provider);
    history.push('/module');
  }
  const registry_name = '' + Object.values(registryModule.attributes)[7];
  const name = registryModule.attributes.name.replace(/-/g, ' ');
  const id = registryModule.id;
  const a_version = Object.assign(
    [],
    Object.values(registryModule.attributes)[4],
  );
  const a_vcsrepo = Object.assign(
    [],
    Object.values(registryModule.attributes)[8],
  );
  const vcsrepo = Object.assign([], Object.values(a_vcsrepo))[3];
  const vcssprovider = Object.assign([], Object.values(a_vcsrepo))[5];
  const version = '' + Object.values(a_version[0])[0];
  return (
    <ModuleRow
      onClick={e =>
        handleClick(
          e,
          registryModule.attributes.name,
          version,
          registryModule.attributes.provider,
          vcsrepo,
          vcssprovider,
        )
      }
      key={id}
    >
      <ModuleName>{name}</ModuleName>
      <ModuleInfo>{registry_name}</ModuleInfo>
      <ModuleInfo>{registryModule.attributes.provider}</ModuleInfo>
      <ModuleInfo>{version}</ModuleInfo>
      {/* <ModuleInfo>{'9 months ago'}</ModuleInfo>
      <ModuleInfo>{'< 100'}</ModuleInfo> */}
    </ModuleRow>
  );
}

const ModuleRow = styled(Row)`
  &:hover {
    background: #f7f8fa;
    border-color: #bac1cc;
    box-shadow: 0 0.125rem 0.1875rem 0 rgb(0 0 0 / 8%);
    cursor: pointer;
  }
  &:last-child {
    margin-bottom: 0;
  }
  margin: 0 0 1rem;
  position: relative;
  width: 100%;
  border-width: 0.0625rem;
  border-style: solid;
  border-color: rgb(235, 238, 242);
  border-image: initial;
  border-radius: 0.375rem;
  overflow: hidden;
  padding: 1.5rem;
`;

const ModuleName = styled.p`
  color: #000;
  font-size: 1.286rem;
  font-weight: 700;
  line-height: 1.5;
  margin: 0 0 1em 0;
`;

const ModuleInfo = styled.span`
  color: #6f7682;
  line-height: 1.5;
  width: auto;
`;
