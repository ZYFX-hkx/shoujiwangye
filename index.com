<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Swipe Navigation</title>
  <style>
    body {
      margin: 0;
      overflow: hidden;
      font-family: Arial, sans-serif;
    }

    .page {
      position: absolute;
      width: 100%;
      height: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
      font-size: 2rem;
      color: white;
      transition: transform 0.5s ease;
    }

    /* Different background colors for pages */
    #page1 {
      background-color: #ff6b6b;
      transform: translateY(0%);
    }

    #page2 {
      background-color: #6bc1ff;
      transform: translateY(100%);
    }

    #page3 {
      background-color: #6bff6e;
      transform: translateY(200%);
    }

    #page4 {
      background-color: #ffa76b;
      transform: translateY(300%);
    }
  </style>
</head>
<body>
  <!-- Pages -->
  <div id="page1" class="page">This is Page 1</div>
  <div id="page2" class="page">This is Page 2</div>
  <div id="page3" class="page">This is Page 3</div>
  <div id="page4" class="page">This is Page 4</div>

  <script>
    let currentPage = 0;
    const pages = document.querySelectorAll('.page');

    function updatePages() {
      pages.forEach((page, index) => {
        page.style.transform = `translateY(${(index - currentPage) * 100}%)`;
      });
    }

    let startY = 0;
    let endY = 0;

    window.addEventListener('touchstart', (e) => {
      startY = e.touches[0].clientY;
    });

    window.addEventListener('touchend', (e) => {
      endY = e.changedTouches[0].clientY;
      if (startY > endY + 50) {
        // Swipe up
        if (currentPage < pages.length - 1) {
          currentPage++;
        }
      } else if (startY < endY - 50) {
        // Swipe down
        if (currentPage > 0) {
          currentPage--;
        }
      }
      updatePages();
    });

    // For mouse drag support
    let isDragging = false;
    window.addEventListener('mousedown', (e) => {
      isDragging = true;
      startY = e.clientY;
    });

    window.addEventListener('mouseup', (e) => {
      if (isDragging) {
        endY = e.clientY;
        if (startY > endY + 50) {
          // Drag up
          if (currentPage < pages.length - 1) {
            currentPage++;
          }
        } else if (startY < endY - 50) {
          // Drag down
          if (currentPage > 0) {
            currentPage--;
          }
        }
        updatePages();
        isDragging = false;
      }
    });
  </script>
</body>
</html>
