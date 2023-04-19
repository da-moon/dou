import React, { useState} from "react";
import { Outlet } from "react-router-dom";
import { tabsData } from '../common/Helpers';
import Button from "./Button";
import './Tabs.css';

const Tabs = () => {
    const [ activeTab, setActiveTab ] = useState(0);

    const handleClick = (index) => {
        setActiveTab(index);
    }

    const tabs = tabsData.map((tab) => {
        return (
            <Button 
                key={tab.id} 
                index={tab.id}
                active={activeTab === tab.id} 
                handleClick={handleClick} 
                name={tab.name}
                path={tab.path} />
        )
    });

    return (
        <React.Fragment>
            <div className="tabs-container">
                {
                    tabs
                }
            </div>

            <Outlet />
        </React.Fragment>
    );
}

export default Tabs;