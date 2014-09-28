module split_flip (
    bbox = [5000, 5000, 5000],
    translation = [0, 0, 0],
    normal = [0, 0, 1]
)
{
    module bbox_ () {
        translate ([-bbox[0]/2, -bbox[1]/2, 0])
        cube (bbox);
    }

    intersection () {
        children ();
        bbox_ ();
    }

    translate (translation)
    intersection () {
        mirror (normal)
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
