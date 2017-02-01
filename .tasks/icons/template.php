<svg
  xmlns="http://www.w3.org/2000/svg"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  style="display: none;">
    <defs>
        <?php foreach ($icons as $name => $data): ?>
            <g class="icon -icon-<?php echo $name ?>" id="icon-<?php echo $name; ?>">
                <?php echo $data['content']; ?>
            </g>
        <?php endforeach; ?>
    </defs>
</svg>
