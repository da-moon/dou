    function convertToMilitaryTime(time) {
        
        const formatAMPM = time.substr(time.length-2);
        const formatTime = `${time.substr(0, time.length-2)} ${formatAMPM}`
        const currentDate = new Date().toLocaleDateString()
        const date = new Date(`${currentDate} ${formatTime}`)
        
        return (date.getHours() * 100).toString().padStart(4, '0')

    }

console.log(convertToMilitaryTime('04:00:00AM'))