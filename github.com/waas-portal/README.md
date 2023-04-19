# WAAS PORTAL

## Install & Start

⚠️ Using [Yarn Package Manager](https://yarnpkg.com) is recommended over `npm`.

Build Go Wrapper Image

Clone repo https://github.com/DigitalOnUs/go-tfe-api-wrapper and build image

```shell
docker build -t gotfeapiwrapper:1.0 .
```

Build Image WaasPortal Image

```shell
docker build -t waasportal:1.0 .
```

Setup environment variables in docker-compose.yaml file
```
environment:
      AUTH_TOKEN: [YOUR_TERRAFORM_TOKEN]
...
    - REACT_APP_AIRFLOWHOST=http://localhost:8080
    - REACT_APP_GOWRAPPER_HOST=http://localhost:8000
    - REACT_APP_GOWRAPPER_ORG=DoU-TFE
```

Run docker-compose
```shell
docker-compose up -d
```

---

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

## License

This project is licensed under the MIT license, Copyright (c) 2019 Maximilian Stoiber.
For more information see `LICENSE.md`.
