<svg
    class="grouped-svg"
    xmlns="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink">
    <?php foreach ($icons as $name => $data): ?>
        <symbol class="icon -icon-<?php echo $name ?>" id="icon-<?php echo $name; ?>" viewBox="<?php echo $data['attributes']['viewBox']; ?>">
            <?php echo $data['content']; ?>
        </symbol>
    <?php endforeach; ?>
</svg>
