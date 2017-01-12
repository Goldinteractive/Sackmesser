<svg class="hide" xmlns="http://www.w3.org/2000/svg">
    <defs>
        <?php foreach ($icons as $name => $content): ?>
            <g id="<?php echo $name; ?>">
                <?php echo $content; ?>
            </g>
        <?php endforeach; ?>
    </defs>
</svg>
