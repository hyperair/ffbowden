module split_flip (
    bbox = [5000, 5000, 5000],
    translation = [0, 0, 0]
)
{
    module bbox_ () {
        translate ([-bbox[0]/2, -bbox[1]/2, 0])
        cube (bbox);
    }

    difference  () {
        children ();

        translate ([0, 0, -bbox[2]])
        bbox_ ();
    }

    translate (translation)
    rotate (180, [0, 1, 0])
    difference () {
        children ();

        bbox_ ();
    }
}

module duplicate_over (
    normal = [0, 0, 1],
    translation = [0, 0, 0]
)
{
    translate (translation) {
        children ();

        mirror (normal)
        children ();
    }
}
