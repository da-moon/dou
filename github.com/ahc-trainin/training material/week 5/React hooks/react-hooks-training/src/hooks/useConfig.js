import { useState, useEffect } from 'react';

function useConfig() {
    const [config, setConfig] = useState(null);

    useEffect(() => {
        refresh();
    }, []);

    const refresh = () => {
        fetch("http://config.com/api/configuration")
            .then(config => setConfig(config))
            .error(err => console.log(error));
    }

    return { config, refresh };
}

export default useConfig;
