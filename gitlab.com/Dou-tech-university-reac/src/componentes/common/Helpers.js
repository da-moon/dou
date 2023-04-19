export const tabsData = [
    {
        id: 0,
        name: "My profile",
        path: "/"
    },
    {
        id: 1,
        name: "Approvals",
        path: "/approvals"
    },
    {
        id: 2,
        name: "Advanced search",
        path: "/advanced-search"
    },
    {
        id: 3,
        name: "Search a profile",
        path: "/search-profile"
    },
];

const usersData = [
    {
        id: 1,
        name: 'Ninfa Nino',
        location: 'Guadalajara, Jalisco',
        jobDescription: 'FrontEnd Developer'
    },
    {
        id: 2,
        name: 'Cesar Becerra',
        location: 'Monterrey, Nuevo Leon',
        jobDescription: 'FrontEnd Manager'
    }
];

export const getUser = (userId) => {
    const user = usersData.filter((user) => {
        return user.id === userId;
    });

    return user[0];
}