function book (pages, pageToGo) {

    const halfBook = pages / 2;

    if (pageToGo <= halfBook) {
        
    return Math.floor(pageToGo / 2);

    } else {
        
        return Math.floor((pages - pageToGo) / 2);

    }

}

console.log(book(10, 8));

